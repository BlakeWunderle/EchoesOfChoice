using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Sanctuary : Ability
    {
        public Sanctuary()
        {
            Name = "Sanctuary";
            FlavorText = "A circle of divine light surrounds an ally, healing their wounds.";
            ModifiedStat = StatEnum.Health;
            Modifier = 25;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 6;
        }
    }
}
