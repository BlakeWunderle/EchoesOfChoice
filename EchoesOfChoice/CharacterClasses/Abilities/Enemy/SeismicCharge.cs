using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class SeismicCharge : Ability
    {
        public SeismicCharge()
        {
            Name = "Seismic Charge";
            FlavorText = "Planted explosives tear apart the ground beneath all enemies.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
            TargetAll = true;
        }
    }
}
