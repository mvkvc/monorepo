use anchor_lang::prelude::*;

#[error_code]
pub enum BountyErrorCodes {
    #[msg("This asset does not exist in bounty.")]
    InvalidAsset,

    #[msg("This worker has already been assigned.")]
    DuplicateWorker,

    #[msg("This bounty period has not expired yet.")]
    BountyNotExpired,

    #[msg("This arbitration period has not expired yet.")]
    ArbitrationNotExpired,
}
