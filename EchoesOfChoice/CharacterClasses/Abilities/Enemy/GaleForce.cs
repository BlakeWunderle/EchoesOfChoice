using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class GaleForce : Ability
    {
        public GaleForce()
        {
            Name = "Gale Force";
            FlavorText = "Violent winds sweep all enemies off their feet.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
            TargetAll = true;
        }
    }
}
