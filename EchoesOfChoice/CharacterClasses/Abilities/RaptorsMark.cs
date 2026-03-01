using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class RaptorsMark : Ability
    {
        public RaptorsMark()
        {
            Name = "Raptor's Mark";
            FlavorText = "Your falcon marks a target, weakening their physical guard.";
            ModifiedStat = StatEnum.PhysicalDefense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
