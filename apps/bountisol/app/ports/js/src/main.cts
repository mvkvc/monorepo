import { z, register, run } from "portboy";
import siws from "./siws";
import sns from "./sns";
import json_schema_to_gbnf from "./json_schema";

const siws_schema = z.object({
    message: z.any(),
    signature: z.any(),
}).strict()

const sns_schema = z.object({
  address: z.string(),
}).strict()

const json_schema_to_gbnf_schema = z.object({
  schema: z.any(),
}).strict()

const registry = register([
    {function: siws, schema: siws_schema, async: true},
    {function: sns, schema: sns_schema, async: true},
    {function: json_schema_to_gbnf, schema: json_schema_to_gbnf_schema, async: false},
])

run(registry);
