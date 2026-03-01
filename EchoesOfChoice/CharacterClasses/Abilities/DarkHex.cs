using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class DarkHex : Ability
    {
        public DarkHex()
        {
            Name = "Dark Hex";
            FlavorText = "Place a powerful dark hex that strips away magical defenses.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 5;
            impactedTurns = 3;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
