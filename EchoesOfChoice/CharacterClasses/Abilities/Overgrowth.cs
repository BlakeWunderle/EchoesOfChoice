using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Overgrowth : Ability
    {
        public Overgrowth()
        {
            Name = "Overgrowth";
            FlavorText = "Channel nature's vitality to heal the entire party.";
            ModifiedStat = StatEnum.Health;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 5;
            TargetAll = true;
        }
    }
}
