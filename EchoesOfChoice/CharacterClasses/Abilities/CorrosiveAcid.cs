using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class CorrosiveAcid : Ability
    {
        public CorrosiveAcid()
        {
            Name = "Corrosive Acid";
            FlavorText = "Hurl a vial of caustic acid that dissolves armor and flesh.";
            ModifiedStat = StatEnum.Health;
            Modifier = 0;
            impactedTurns = 3;
            UseOnEnemy = true;
            ManaCost = 4;
            DamagePerTurn = 4;
        }
    }
}
