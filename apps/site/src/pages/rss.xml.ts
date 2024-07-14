import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import { siteConfig } from "@/site-config";
import { editSlug } from "@/utils";

export const get = async () => {
	let posts = await getCollection("post");
	posts = posts.filter((post) => typeof post.data.draft !== "boolean" || !post.data.draft);

	return rss({
		title: siteConfig.title,
		description: siteConfig.description,
		site: import.meta.env.SITE,
		items: posts.map((post) => ({
			title: post.data.title,
			description: post.data.description,
			pubDate: post.data.publishDate,
			link: `posts/${editSlug(post.slug)}`,
		})),
	});
};
