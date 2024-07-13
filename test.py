try:
    from transformers import pipeline
    from scs.incremental_parse import IncrementalParser, SpecialToken, ParseFailure
    from tensorflow import keras
    print("All imports successful")
except ImportError as e:
    print(f"Import error: {e}")


schema = """
{
    output: string,
    array_output: []number,
    optional_output?: number,
    nested_schema: []{
        inner_output: string
    }
}
"""

# Load the gpt2 model
pipe = pipeline('text-generation', model='gpt2')

# Generate output
output = pipe('Input')

# Example of how to manually enforce JSON schema (simplified)
import jsonschema

schema_dict = {
    "type": "object",
    "properties": {
        "output": {"type": "string"},
        "array_output": {"type": "array", "items": {"type": "number"}},
        "optional_output": {"type": "number"},
        "nested_schema": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "inner_output": {"type": "string"}
                },
                "required": ["inner_output"]
            }
        }
    },
    "required": ["output", "array_output", "nested_schema"]
}

# Validate the output
try:
    jsonschema.validate(instance=output, schema=schema_dict)
    print("Output is valid")
except jsonschema.exceptions.ValidationError as e:
    print(f"Output is invalid: {e.message}")
