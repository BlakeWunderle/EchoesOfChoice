using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Fortify : Ability
    {
        public Fortify()
        {
            Name = "Fortify";
            FlavorText = "Reinforce armor and brace for the worst. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
