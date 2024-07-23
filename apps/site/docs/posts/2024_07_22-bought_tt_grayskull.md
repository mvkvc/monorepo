---
date: 2024-07-22
authors:
  - mvkvc
categories:
  - tenstorrent
draft: true
---

# I bought a Tenstorrent card

I ordered a Tenstorrent [Grayskull](https://tenstorrent.com/hardware/grayskull) card to see what I could get working. I want to gets my hands dirty and learn how the models get translated to the hardware. Also a large amount of Tenstorrent's [code](https://github.com/tenstorrent) is open source and I want to get involved and support a company like that where I can. I want to live in a world where I can patch all the software I use especially the ones running the hardware I own.

<!-- Go into what makes their approach interesting -->

Tenstorrent has two approaches to implementing models for their hardware. 

At a low level you can use their [ttnn]() library, which is a lower level library of tensor operations. You can import tensors from torch to get the model weights but then you need to reimplement the models in ttnn which is optimized for their hardware.

<!-- Show ttnn examples -->

 The other approach is with [pybuda](), a framework for running off-the-shelf models where the models are compiled from other frameworks such as Torch and ONNX to be able to run on the hardware.

<!-- How do they do this -->

<!-- Show examples -->

Here are some performance comparisons between the two approaches currently to show the power of using native abstractions.

<!-- Show comparisons -->

Overall I am impressed so far with their progress and the transparency and will try to put my card to good use finding some rough edges in the ecosystem.
