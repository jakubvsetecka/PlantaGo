from guidance import models, gen, system, user, assistant, guidance, select
from guidance import *

# Define the guidance model using a local LLM (e.g., LLaMA)
# You'll need to have the model weights downloaded and the appropriate library installed
llama3 = models.LlamaCpp("/mnt/d/programovani/MOJE/models/Meta-Llama-3-8B.Q3_K_S.gguf")
print("Model loaded\n")

@guidance
def spell_generator(lm, plant1, plant2):
    with system():
        lm += f"""
        You are a magical botanist who creates spells by combining plants.
        Create a spell by combining the properties of {plant1} and {plant2}.
        The spell must follow this structure:
        - Type: Either Fire or Water
        - If Fire:
          - Damage: An integer
          - Reach: An integer
          - Rate of Fire: An integer
          - Fire Damage: An integer
        - If Water:
          - Healing: An integer
          - Reach: An integer
          - Rate of Fire: An integer
        """

    with user():
        lm += f"Create a spell combining {plant1} and {plant2}."

    with assistant():
        lm += "Here's the spell structure:\n\n"

        lm += "Type: "
        lm += select(["Fire", "Water"], name='answer')
        lm += "\n"

        if lm['answer'] == "Fire":
            lm += 'Damage: ' + f"{gen(name='damage', regex=r'[0-9]+')}"
            lm += 'Reach: ' + f"{gen(name='reach', regex=r'[0-9]+')}"
            lm += 'Rate of Fire: ' + f"{gen(name='rate_of_fire', regex=r'[0-9]+')}"
            lm += 'Fire Damage: ' + f"{gen(name='fire_damage', regex=r'[0-9]+')}"
        else:  # Water
            lm += 'Healing: ' + f"{gen(name='healing', regex=r'[0-9]+')}"
            lm += 'Reach: + ' + f"{gen(name='reach', regex=r'[0-9]+')}"
            lm += 'Rate of Fire: ' + f"{gen(name='rate_of_fire', regex=r'[0-9]+')}"

    return lm

# Example usage
plant1 = "Sunflower"
plant2 = "Aloe Vera"
lm = llama3 + spell_generator(plant1, plant2)
print(str(lm))
