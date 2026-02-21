using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Confuse : Ability
    {
        public Confuse()
        {
            Name = "Confuse";
            FlavorText = "A psychic pulse scrambles the enemy's thoughts, weakening their magical resistance.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
