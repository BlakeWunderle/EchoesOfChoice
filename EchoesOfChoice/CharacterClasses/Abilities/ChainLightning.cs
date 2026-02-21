using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ChainLightning : Ability
    {
        public ChainLightning()
        {
            Name = "Chain Lightning";
            FlavorText = "Lightning arcs from one target to the next.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
