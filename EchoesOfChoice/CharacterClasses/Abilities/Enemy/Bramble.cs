using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Bramble : Ability
    {
        public Bramble()
        {
            Name = "Bramble";
            FlavorText = "Thorny vines lash out with nature's fury.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
