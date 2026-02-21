using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class TripleArrow : Ability
    {
        public TripleArrow()
        {
            Name = "Triple Arrow";
            FlavorText = "Loose three arrows in rapid succession, one for each enemy.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
            TargetAll = true;
        }
    }
}
