use anchor_lang::{prelude::*, system_program};
use anchor_spl::token::{transfer, Mint, Token, TokenAccount, Transfer};

use crate::errors::*;

#[account]
pub struct Bounty {
    pub bump: u8,
    pub assets: Vec<Pubkey>,
    pub admin: Pubkey,
    pub creator: Pubkey,
    pub workers: Vec<Pubkey>,
}

impl Bounty {
    pub const SEED_PREFIX: &'static str = "bountisol_bounty";
    pub const SPACE: usize = 8 + 1 + 4 + 8 + 8 + 8 + 1 + 32 + 32 + 4; // https://book.anchor-lang.com/anchor_references/space.html

    pub fn new(
        bump: u8,
        admin: Pubkey,
        creator: Pubkey,
    ) -> Self {
        Self {
            bump,
            assets: vec![],
            admin,
            creator,
            workers: vec![],
        }
    }
}

pub trait BountyAccount<'info> {
    fn realloc(
        &mut self,
        space_to_add: usize,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()>;

    fn check_asset(&self, key: &Pubkey) -> Result<()>;

    fn check_worker(&self, key: &Pubkey) -> Result<()>;

    fn add_asset(
        &mut self,
        key: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()>;

    fn add_worker(
        &mut self,
        worker: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()>;

    fn assign(
        &mut self,
        worker: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()>;

    fn fund(
        &mut self,
        tx: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        authority: &Signer<'info>,
        system_program: &Program<'info, System>,
        token_program: &Program<'info, Token>,
    ) -> Result<()>;

    fn release(
        &mut self,
        tx: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        token_program: &Program<'info, Token>,
    ) -> Result<()>;
}

impl<'info> BountyAccount<'info> for Account<'info, Bounty> {
    fn realloc(
        &mut self,
        space_to_add: usize,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()> {
        let account_info = self.to_account_info();
        let new_account_size = account_info.data_len() + space_to_add;

        // Determine additional rent required
        let lamports_required = (Rent::get()?).minimum_balance(new_account_size);
        let additional_rent_to_fund = lamports_required - account_info.lamports();

        // Perform transfer of additional rent
        system_program::transfer(
            CpiContext::new(
                system_program.to_account_info(),
                system_program::Transfer {
                    from: payer.to_account_info(),
                    to: account_info.clone(),
                },
            ),
            additional_rent_to_fund,
        )?;

        // Reallocate the account
        account_info.realloc(new_account_size, false)?;
        Ok(())
    }

    fn check_asset(&self, asset: &Pubkey) -> Result<()> {
        if self.assets.contains(asset) {
            Ok(())
        } else {
            Err(BountyErrorCodes::InvalidAsset.into())
        }
    }

    fn check_worker(&self, worker: &Pubkey) -> Result<()> {
        if !self.assets.contains(worker) {
            Ok(())
        } else {
            Err(BountyErrorCodes::DuplicateWorker.into())
        }
    }

    fn add_asset(
        &mut self,
        asset: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()> {
        match self.check_asset(&asset) {
            Ok(()) => (),
            Err(_) => {
                self.realloc(32, payer, system_program)?;
                self.assets.push(asset)
            }
        };
        Ok(())
    }

    fn add_worker(
        &mut self,
        worker: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()> {
        match self.check_worker(&worker) {
            Ok(()) => (),
            Err(_) => {
                self.realloc(32, payer, system_program)?;
                self.assets.push(worker)
            }
        };
        Ok(())
    }

    fn assign(
        &mut self,
        worker: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()> {
        self.check_worker(&worker)?;
        self.add_worker(worker, payer, system_program)?;
        Ok(())
    }

    fn fund(
        &mut self,
        tx: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        authority: &Signer<'info>,
        system_program: &Program<'info, System>,
        token_program: &Program<'info, Token>,
    ) -> Result<()> {
        let (mint, from, to, amount) = tx;
        self.add_asset(mint.key(), authority, system_program)?;
        process_transfer_in(from, to, amount, authority, token_program)?;
        Ok(())
    }

    fn release(
        &mut self,
        tx: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        token_program: &Program<'info, Token>,
    ) -> Result<()> {
        let (mint, from, to, amount) = tx;
        self.check_asset(&mint.key())?;
        process_transfer_out(from, to, amount, self, token_program)?;
        Ok(())
    }
}

fn process_transfer_in<'info>(
    from: &Account<'info, TokenAccount>,
    to: &Account<'info, TokenAccount>,
    amount: u64,
    authority: &Signer<'info>,
    token_program: &Program<'info, Token>,
) -> Result<()> {
    transfer(
        CpiContext::new(
            token_program.to_account_info(),
            Transfer {
                from: from.to_account_info(),
                to: to.to_account_info(),
                authority: authority.to_account_info(),
            },
        ),
        amount,
    )
}

fn process_transfer_out<'info>(
    from: &Account<'info, TokenAccount>,
    to: &Account<'info, TokenAccount>,
    amount: u64,
    bounty: &Account<'info, Bounty>,
    token_program: &Program<'info, Token>,
) -> Result<()> {
    transfer(
        CpiContext::new_with_signer(
            token_program.to_account_info(),
            Transfer {
                from: from.to_account_info(),
                to: to.to_account_info(),
                authority: bounty.to_account_info(),
            },
            &[&[Bounty::SEED_PREFIX.as_bytes(), &[bounty.bump]]],
        ),
        amount,
    )
}
