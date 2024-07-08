import { z, defineCollection } from "astro:content";
import { strToDate } from "@/utils";

function removeDupsAndLowerCase(array: string[]) {
	if (!array.length) return array;
	const lowercaseItems = array.map((str) => str.toLowerCase());
	const distinctItems = new Set(lowercaseItems);
	return Array.from(distinctItems);
}

const post = defineCollection({
	schema: z.object({
		title: z.string().max(60),
		description: z.string().min(0).max(160),
		// publishDate: z.string().transform((str) => new Date(str)),
		publishDate: z.string().transform((str) => strToDate(str)),
		tags: z.array(z.string()).default([]).transform(removeDupsAndLowerCase),
		ogImage: z.string().optional(),
		draft: z.boolean().optional(),
	}),
});

export const collections = { post };