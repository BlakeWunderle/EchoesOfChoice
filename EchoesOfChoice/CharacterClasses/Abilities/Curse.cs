using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Curse : Ability
    {
        public Curse()
        {
            Name = "Curse";
            FlavorText = "A dark hex that weakens magical resistance.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
