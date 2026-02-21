using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ServoStrike : Ability
    {
        public ServoStrike()
        {
            Name = "Servo Strike";
            FlavorText = "Mechanical limbs lash out with calculated force.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
