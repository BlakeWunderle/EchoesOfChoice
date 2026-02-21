using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Guard : Ability
    {
        public Guard()
        {
            Name = "Guard";
            FlavorText = "Brace for impact. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 2;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 1;
        }
    }
}
