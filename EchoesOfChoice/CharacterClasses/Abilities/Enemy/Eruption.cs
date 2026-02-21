using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Eruption : Ability
    {
        public Eruption()
        {
            Name = "Eruption";
            FlavorText = "The ground splits open, spewing fire in all directions.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 6;
            TargetAll = true;
        }
    }
}
