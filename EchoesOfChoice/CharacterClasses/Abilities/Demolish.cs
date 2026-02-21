using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Demolish : Ability
    {
        public Demolish()
        {
            Name = "Demolish";
            FlavorText = "Identify structural weak points and bring them crashing down. Reduces defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
