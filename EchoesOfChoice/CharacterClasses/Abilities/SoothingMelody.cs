using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SoothingMelody : Ability
    {
        public SoothingMelody()
        {
            Name = "Soothing Melody";
            FlavorText = "A gentle song that mends body and spirit. Restores health.";
            ModifiedStat = StatEnum.Health;
            Modifier = 10;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 5;
            TargetAll = true;
        }
    }
}
