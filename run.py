from llama_cpp import Llama

model_path = "/mnt/d/programovani/MOJE/llama3/Meta-Llama-3-8B"

try:
    llm = Llama(model_path=model_path, n_ctx=2048)
    print("Model loaded successfully!")
    
    # Test the model with a simple prompt
    prompt = "Once upon a time,"
    output = llm(prompt, max_tokens=20)
    print(f"Test output: {output['choices'][0]['text']}")
except Exception as e:
    print(f"Failed to load the model. Error: {str(e)}")
