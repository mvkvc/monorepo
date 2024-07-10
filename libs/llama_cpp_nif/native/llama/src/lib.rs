use llama_cpp::{LlamaModel, LlamaParams, SessionParams};
use llama_cpp::standard_sampler::StandardSampler;
use rustler::{Env, NifStruct, ResourceArc, Term};
use std::ops::Deref;

pub struct ExLlamaRef {
    pub model: LlamaModel,
    pub sampler: StandardSampler,
}

#[derive(NifStruct)]
#[module = "LLAMACPPNIF.Model"]
pub struct ExLlama {
    pub resource: ResourceArc<ExLlamaRef>,
}

impl ExLlama {
    pub fn new(model: LlamaModel, sampler: StandardSampler) -> Self {
        Self {
            resource: ResourceArc::new(ExLlamaRef { model, sampler }),
        }
    }
}

impl ExLlamaRef {
    pub fn new(model: LlamaModel, sampler: StandardSampler) -> Self {
        Self { model, sampler }
    }
}

impl Deref for ExLlama {
    type Target = ExLlamaRef;

    fn deref(&self) -> &Self::Target {
        &self.resource
    }
}

unsafe impl Send for ExLlamaRef {}
unsafe impl Sync for ExLlamaRef {}

#[derive(NifStruct)]
#[module = "LLAMACPPNIF.SamplerOptions"]
struct ExSamplerOptions {
    pub temp: f32,
    pub grammar: String
}

impl From<ExSamplerOptions> for StandardSampler {
    fn from(a: ExSamplerOptions) -> Self {
        Self {
            temp: a.temp,
            grammar: a.grammar,
            ..Self::default()
        }
    }
}

fn on_load(env: Env, _load_info: Term) -> bool {
    rustler::resource!(ExLlamaRef, env);
    true
}

#[rustler::nif(schedule = "DirtyCpu")]
fn new(path: String, sampler_options: ExSamplerOptions) -> Result<ExLlama, ()> {
    let params = LlamaParams::default();
    let model = LlamaModel::load_from_file(path, params).expect("Could not load model");
    let sampler = StandardSampler::from(sampler_options);

    Ok(ExLlama::new(model, sampler))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn predict(llama: ExLlama, prompt: String, max_tokens: u32) -> String {
    let ctx = &mut llama.model.create_session(SessionParams::default());
    let actual_prompt: String = prompt.clone() + "\n";
    ctx.advance_context(actual_prompt).unwrap();

    let max_completions: u32 = max_tokens.try_into().unwrap();
    let mut decoded_tokens = 0;

    let sampler = llama.sampler.clone();

    let completions = ctx.start_completing_with(sampler, max_completions.try_into().unwrap());

    let mut buffer: String = String::new();

    while let Some(next_token) = completions.next_token() {
        let token: &[u8] = llama.model.detokenize(next_token);

        let new_str = String::from_utf8_lossy(token);
        buffer.push_str(new_str.as_ref());

        decoded_tokens += 1;

        if decoded_tokens > max_tokens {
            break;
        }
    }

    // Figure out tokenization
    let result = buffer
        .replace("▁", " ")
        .replace("<0x0A>", "\n")
        .replace("A: ", "")
        .replace("</s>", "")
        .trim()
        .to_string();

    return result;

}

rustler::init!(
    "Elixir.LLAMACPPNIF",
    [predict, new],
    load = on_load
);
