using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Aegis : Ability
    {
        public Aegis()
        {
            Name = "Aegis";
            FlavorText = "A shimmering ward deflects hostile magic.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
