using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Consecrate : Ability
    {
        public Consecrate()
        {
            Name = "Consecrate";
            FlavorText = "Holy ground repels dark magic.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
