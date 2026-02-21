using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Serenade : Ability
    {
        public Serenade()
        {
            Name = "Serenade";
            FlavorText = "A gentle melody that mends wounds.";
            ModifiedStat = StatEnum.Health;
            Modifier = 15;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 4;
        }
    }
}
