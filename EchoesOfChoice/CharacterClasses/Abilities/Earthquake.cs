using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Earthquake : Ability
    {
        public Earthquake()
        {
            Name = "Earthquake";
            FlavorText = "The ground tears apart beneath all enemies.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
            TargetAll = true;
        }
    }
}
