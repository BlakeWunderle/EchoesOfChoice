using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class SweepingSlash : Ability
    {
        public SweepingSlash()
        {
            Name = "Sweeping Slash";
            FlavorText = "Swing your blade in a large circle damaging the enemy.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
