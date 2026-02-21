using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SmokeBomb : Ability
    {
        public SmokeBomb()
        {
            Name = "Smoke Bomb";
            FlavorText = "Vanish into a cloud of smoke. Harder to hit what you can't see.";
            ModifiedStat = StatEnum.DodgeChance;
            Modifier = 3;
            impactedTurns = 1;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
