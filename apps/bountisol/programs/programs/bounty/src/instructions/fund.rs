use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::events::*;
use crate::state::*;

pub fn fund(ctx: Context<FundBounty>, amount: u64) -> Result<()> {
    let bounty = &mut ctx.accounts.bounty;

    let tx = (
        &ctx.accounts.mint,
        &ctx.accounts.payer_token_account,
        &ctx.accounts.bounty_token_account,
        amount,
    );

    match bounty.fund(
        tx,
        &ctx.accounts.payer,
        &ctx.accounts.system_program,
        &ctx.accounts.token_program,
    ) {
        Ok(_) => {
            emit!(BountyFunded {
                address: ctx.accounts.bounty.key(),
                from: ctx.accounts.payer.key(),
                token: ctx.accounts.mint.key(),
                amount: amount,
            });
            Ok(())
        }
        Err(err) => {
            return Err(err);
        }
    }
}

#[derive(Accounts)]
pub struct FundBounty<'info> {
    #[account(
        mut,
        seeds = [Bounty::SEED_PREFIX.as_bytes()],
        bump = bounty.bump,
    )]
    pub bounty: Account<'info, Bounty>,
    pub mint: Account<'info, token::Mint>,
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = bounty,
    )]
    pub bounty_token_account: Account<'info, token::TokenAccount>,
    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = payer,
    )]
    pub payer_token_account: Account<'info, token::TokenAccount>,
    #[account(mut)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
    pub token_program: Program<'info, token::Token>,
    pub associated_token_program: Program<'info, associated_token::AssociatedToken>,
}
