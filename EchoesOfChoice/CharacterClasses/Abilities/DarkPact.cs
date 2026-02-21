using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class DarkPact : Ability
    {
        public DarkPact()
        {
            Name = "Dark Pact";
            FlavorText = "Forbidden power surges through the warlock, greatly amplifying magical might.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 7;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 4;
        }
    }
}
