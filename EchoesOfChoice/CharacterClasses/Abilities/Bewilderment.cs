using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Bewilderment : Ability
    {
        public Bewilderment()
        {
            Name = "Bewilderment";
            FlavorText = "Illusory visions shatter the enemy's focus.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
