import { convertJsonSchemaToGbnf } from "json-schema-to-gbnf";

export default function json_schema_to_gbnf(schema: object): string {
  return convertJsonSchemaToGbnf(schema);
}
