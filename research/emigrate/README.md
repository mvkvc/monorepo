# emigrate

Migrate RAG vectors in PGVector to a new embedding space.

## Background

You have an application which has a large amount of embedding vectors. There is a new model available or you want to fine-tune a custom model in order to get better performance. However it is expensive to re-embed all of your historical data.

## Goal

The goal of this experiment is to see if you can train an adapter that effectively projects one embedding space into another for RAG applications.

## Evaluation

For our use case we are not talking on performance but compatibility. Therefore the evaluation metric to be used is for the same RAG query we want the results returned to be as close as possible to the original model when the input embedding and/or some mix of the stored embeddings have been embedded with a new model.
