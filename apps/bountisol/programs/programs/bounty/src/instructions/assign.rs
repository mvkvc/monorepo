use anchor_lang::prelude::*;

use crate::events::*;
use crate::state::*;

pub fn assign(ctx: Context<AssignBounty>, worker: Pubkey) -> Result<()> {
    let bounty = &mut ctx.accounts.bounty;

    match bounty.assign(worker, &ctx.accounts.payer, &ctx.accounts.system_program) {
        Ok(_) => {
            emit!(BountyAssigned {
                address: ctx.accounts.bounty.key(),
                worker: worker,
            });
            Ok(())
        }
        Err(err) => {
            return Err(err);
        }
    }
}

#[derive(Accounts)]
pub struct AssignBounty<'info> {
    #[account(
        mut,
        seeds = [Bounty::SEED_PREFIX.as_bytes()],
        bump = bounty.bump,
    )]
    pub bounty: Account<'info, Bounty>,
    #[account(mut, constraint = *payer.owner == bounty.admin || *payer.owner == bounty.creator)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
}
