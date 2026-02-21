using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class HuntersMark : Ability
    {
        public HuntersMark()
        {
            Name = "Hunter's Mark";
            FlavorText = "Mark the prey, exposing their weak points. Reduces defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
