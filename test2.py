import guidance
from guidance import one_or_more, select, zero_or_more, models

llama3 = models.LlamaCpp("/mnt/d/programovani/MOJE/models/Meta-Llama-3-8B.Q2_K.gguf")

# stateless=True indicates this function does not depend on LLM generations
@guidance(stateless=True)
def number(lm):
    n = one_or_more(select(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']))
    # Allow for negative or positive numbers
    return lm + select(['-' + n, n])

@guidance(stateless=True)
def operator(lm):
    return lm + select(['+' , '*', '**', '/', '-'])

@guidance(stateless=True)
def expression(lm):
    # Either
    # 1. A number (terminal)
    # 2. two expressions with an operator and optional whitespace
    # 3. An expression with parentheses around it
    return lm + select([
        number(),
        expression() + zero_or_more(' ') +  operator() + zero_or_more(' ') +  expression(),
        '(' + expression() + ')'
    ])

grammar = expression()
lm = llama3 + 'Problem: Luke has a hundred and six balls. He then loses thirty six.\n'
lm += 'Equivalent arithmetic expression: ' + grammar + '\n'

print(str(lm))
