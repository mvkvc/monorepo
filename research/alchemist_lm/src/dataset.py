from datasets import load_dataset
from datasets import Dataset
from datasets import Features, Value
from transformers import AutoTokenizer
import os

DATA_ROOT = os.path.abspath("../data")


def download_stack():
    ds = load_dataset("bigcode/the-stack", data_dir="data/elixir", split="train")
    ds.save_to_disk(DATA_ROOT + "/stack")
    ds.push_to_hub("mvkvc/stack_elixir")


def walk_dir(path, exclude):
    for root, dirs, files in os.walk(os.path.abspath(path)):
        dirs[:] = [d for d in dirs if d not in exclude]
        for file in files:
            if file not in exclude:
                path = os.path.join(root, file)
                yield process_file(path)


def process_file(path):
    with open(path, "r") as f:
        text = f.read()

    folder = os.path.dirname(path)
    folder_split = folder.split("/")
    package = folder_split[0]
    version = folder_split[1]
    path_sep = path.split("/")[-1]
    path = path_sep.replace("_%", "/")

    return {"text": text, "path": path, "package": package, "version": version}


def process():
    data_dir = DATA_ROOT + "/hex"
    dataset_dir = DATA_ROOT + "../hex_dataset"
    dataset_encoded_dir = DATA_ROOT + "../hex_dataset_encoded"
    files_exclude = [".keep"]
    dataset_name = "mvkvc/hex_elixir"
    dataset_encoded_name = "mvkvc/hex_elixir_encoded"

    features = Features(
        {
            "text": Value("string"),
            "path": Value("string"),
            "package": Value("string"),
            "version": Value("string"),
        }
    )

    gen = walk_dir(data_dir, files_exclude)
    s = Dataset.from_generator(gen)

    print(s)

    # dataset = load_dataset(
    #     "text",
    #     data_files=files,
    #     sample_by="document",
    #     features=features,
    # )

    # print("Dataset loaded")

    # dataset = dataset.map(process_files)

    # print("Dataset processed")

    # print(dataset["train"][:3])

    # dataset.push_to_hub(dataset_name)

    # tokenizer = AutoTokenizer.from_pretrained("codellama/CodeLlama-7b-hf")

    # dataset_encoded = dataset.map(
    #     lambda examples: tokenizer(examples["text"]), batched=True
    # )

    # dataset_encoded.save_to_disk(os.path.abspath(dataset_encoded_dir))
    # dataset_encoded.push_to_hub(dataset_encoded_name)


if __name__ == "__main__":
    # process()
    download_stack()
