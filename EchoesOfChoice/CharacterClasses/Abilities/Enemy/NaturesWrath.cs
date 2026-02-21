using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class NaturesWrath : Ability
    {
        public NaturesWrath()
        {
            Name = "Nature's Wrath";
            FlavorText = "Raw nature magic surges forward in a torrent of energy.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
