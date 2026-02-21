using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Brimstone : Ability
    {
        public Brimstone()
        {
            Name = "Brimstone";
            FlavorText = "Infernal flames consume everything in their path.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
