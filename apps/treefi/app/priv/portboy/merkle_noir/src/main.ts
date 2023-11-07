// @ts-ignore -- no types
import { Fr } from '@aztec/bb.js';
import { z, register, run } from "portboy";
import { MerkleTree } from "./merkleTree.js";

const isPowerOfTwo = (n: number): boolean => {
    return (n & (n - 1)) === 0;
}

const calculateMerkleRootSchema = z.object({
    leaves: z.array(z.string()),
});

const calculateMerkleRoot = async (leaves: string[]): Promise<string> => {
    if (!isPowerOfTwo(leaves.length)) {
        throw new Error("Number of leaves must be a power of two");
    }

    const fieldleaves = leaves.map((leaf) => Fr.fromString(leaf));
    const treeHeight = Math.ceil(Math.log2(leaves.length));
    const tree = new MerkleTree(treeHeight);
    console.log(`Tree: ${tree}`)
    await tree.initialize(fieldleaves);
    const root = tree.root()
    console.log(`Root: ${root}`)

    return root.toString();
};

const registry = register([
    {function: calculateMerkleRoot, schema: calculateMerkleRootSchema}
])

run(registry);

// Testing
// const treeLength = 16
// const data = Array.from({length: treeLength}, (_, i) => i.toString());
// const root = await calculateMerkleRoot(data)
// console.log(`Root: ${root}`)
