using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Torment : Ability
    {
        public Torment()
        {
            Name = "Torment";
            FlavorText = "Waves of psychic anguish tear at the enemy's resolve and guard.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 6;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
