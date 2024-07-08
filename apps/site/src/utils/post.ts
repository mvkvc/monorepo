import type { CollectionEntry } from "astro:content";

export function sortMDByDate(posts: CollectionEntry<"post">[] = []) {
	return posts.sort(
		(a, b) => new Date(b.data.publishDate).valueOf() - new Date(a.data.publishDate).valueOf()
	);
}

export function filterDrafts(posts: CollectionEntry<"post">[] = []) {
	if (import.meta.env.DEV) {
		return posts;
	} else {
		return posts.filter((post) => !post.data.draft);
	}
}

export function getUniqueTags(posts: CollectionEntry<"post">[] = []) {
	const uniqueTags = new Set<string>();
	posts.forEach((post) => {
		post.data.tags.map((tag) => uniqueTags.add(tag));
	});
	return Array.from(uniqueTags);
}

export function getUniqueTagsWithCount(posts: CollectionEntry<"post">[] = []): {
	[key: string]: number;
} {
	return posts.reduce((prev, post) => {
		const runningTags: { [key: string]: number } = { ...prev };
		post.data.tags.forEach((tag) => {
			runningTags[tag] = (runningTags[tag] || 0) + 1;
		});
		return runningTags;
	}, {});
}

export function strToDate(dateStr: string, prefix = "20") {
	let date = new Date(dateStr);

	if (isNaN(date.getTime())) {
		const dateArr = dateStr.split("/");
		if (dateArr[0].length === 2) {
			dateArr[0] = prefix + dateArr[0];
		}
		const newStrDate = dateArr.join("/");
		date = new Date(newStrDate);
	}

	return date;
}

export function editSlug(slug: string) {
	return slug.split("_")[1];
}
