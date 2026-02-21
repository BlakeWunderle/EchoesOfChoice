using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class WarWard : Ability
    {
        public WarWard()
        {
            Name = "War Ward";
            FlavorText = "A shimmering ward deflects hostile magic.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
