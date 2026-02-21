using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class CalledShot : Ability
    {
        public CalledShot()
        {
            Name = "Called Shot";
            FlavorText = "Take careful aim at a vital spot. This is going to hurt.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
