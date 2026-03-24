import { defineCollection, z } from 'astro:content';

const packages = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    weight: z.number(),
    thumbnail: z.string().optional(),
    heroImage: z.string().optional(),
    price: z.string().optional(),
  }),
});

export const collections = { packages };
