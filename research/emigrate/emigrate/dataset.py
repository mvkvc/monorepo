import asyncio
import os

from datasets import load_dataset, load_from_disk
from openai import AsyncOpenAI
from tqdm import tqdm

seed = 42
n_rows = 100_000
n_rows_query = 1000
save_dir = ".dataset/cohere_wiki_22_12"
dataset = "Cohere/wikipedia-22-12"
lang = "en"
preamble = """
For the following text, construct a query that a user might ask that would be answered by the text. The query should be a question that the text answers. Return ONLY the query.\n
"""
text_start = "TEXT START:\n"
text_end = "TEXT END."
model = "meta-llama/Meta-Llama-3-70B-Instruct"
embed_origin = "all-MiniLM-L6-v2"
embed_target = "nomic-ai/nomic-embed-text-v1"


def get_openai_client(base_url=None, api_key=None):
    base_url = base_url or os.environ["OPENAI_BASE_URL"]
    api_key = api_key or os.environ["OPENAI_API_KEY"]

    if not base_url and not api_key:
        raise ValueError(
            "Please set the OPENAI_BASE_URL and OPENAI_API_KEY environment variables."
        )

    return AsyncOpenAI(
        base_url=base_url,
        api_key=api_key,
    )


async def generate_query(client, prompt, model=model):
    result = await client.chat.completions.create(
        **{
            "model": model,
            "messages": [{"role": "user", "content": prompt}],
            "temperature": 0,
        }
    )

    return result.choices[0].message.content


def query_fn(text, preamble=preamble, text_start=text_start, text_end=text_end):
    return f"{preamble}\n{text_start}\n{text}\n{text_end}"


def load_data(save_dir=save_dir, dataset=dataset, lang=lang):
    if os.path.exists(save_dir):
        data = load_from_disk(save_dir)
    else:
        data = load_dataset(dataset, lang, split="train", trust_remote_code=True)
        data.save_to_disk(save_dir)

    return data


async def generate_data(
    client, data, n_rows=n_rows, n_rows_query=n_rows_query, seed=seed
):
    data_rows = len(data)

    assert n_rows <= data_rows, f"n_rows must be less than or equal to {data_rows}"

    data = data.select_columns(["id", "text"])
    data = data.select(range(n_rows))
    data = data.map(lambda row: {"query": "", **row})
    data = data.shuffle(seed=seed)

    for i in tqdm(range(n_rows_query)):
        text = data[i]["text"]
        prompt = query_fn(text)
        query = await generate_query(client, prompt)
        data[i]["query"] = query
        tqdm.write(f"QUERY: {query} -- TEXT: {text}")

    return data


async def main():
    query_data_path = f"{save_dir}_{n_rows}_queries_{n_rows_query}"

    # client = get_openai_client()
    # raw_data = load_data()
    # data = await generate_data(client, raw_data)
    # data.save_to_disk(query_data_path)
    data = load_from_disk(query_data_path)

    print(data)
    print(data[0:4])


if __name__ == "__main__":
    asyncio.run(main())
