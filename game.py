import pygame
import json

# Initialize pygame
pygame.init()

# Constants
WIDTH, HEIGHT = 800, 600
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
FPS = 60

# Load spells from JSON file
with open('spells.json') as f:
    spells = json.load(f)

# Screen setup
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("2D Spellcaster Game")

# Player setup
player_pos = [WIDTH // 2, HEIGHT // 2]
player_speed = 5

# Spell class
class Spell:
    def __init__(self, name, color, area_of_effect, damage, velocity, heal):
        self.name = name
        self.color = color
        self.area_of_effect = area_of_effect
        self.damage = damage
        self.velocity = velocity
        self.heal = heal
        self.pos = player_pos.copy()
        self.direction = [0, 0]

    def update(self):
        self.pos[0] += self.direction[0] * self.velocity
        self.pos[1] += self.direction[1] * self.velocity

    def draw(self, surface):
        pygame.draw.circle(surface, self.color, self.pos, self.area_of_effect)

# Function to cast a spell
def cast_spell(spell_data, direction):
    spell = Spell(spell_data['name'], spell_data['color'], spell_data['area_of_effect'], spell_data['damage'], spell_data['velocity'], spell_data['heal'])
    spell.direction = direction
    return spell

# Main loop
running = True
clock = pygame.time.Clock()
spells_cast = []
spell_idx = 0

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    keys = pygame.key.get_pressed()

    if keys[pygame.K_w]:
        player_pos[1] -= player_speed
    if keys[pygame.K_s]:
        player_pos[1] += player_speed
    if keys[pygame.K_a]:
        player_pos[0] -= player_speed
    if keys[pygame.K_d]:
        player_pos[0] += player_speed

    if keys[pygame.K_SPACE]:  # Example: Cast the first spell in the JSON file
        spell_direction = [1, 0]  # Example direction to the right
        new_spell = cast_spell(spells[spell_idx], spell_direction)
        spells_cast.append(new_spell)

    if keys[pygame.K_TAB]:
        spell_idx = (spell_idx + 1) % len(spells)

    # Update spells
    for spell in spells_cast:
        spell.update()

    # Draw everything
    screen.fill(WHITE)
    pygame.draw.rect(screen, BLACK, (*player_pos, 50, 50))  # Draw player

    for spell in spells_cast:
        spell.draw(screen)

    pygame.display.flip()
    clock.tick(FPS)

pygame.quit()
