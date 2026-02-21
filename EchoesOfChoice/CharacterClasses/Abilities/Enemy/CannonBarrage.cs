using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class CannonBarrage : Ability
    {
        public CannonBarrage()
        {
            Name = "Cannon Barrage";
            FlavorText = "A thunderous volley of cannon fire rains down on the entire party.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
            TargetAll = true;
        }
    }
}
