using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SpectralLance : Ability
    {
        public SpectralLance()
        {
            Name = "Spectral Lance";
            FlavorText = "Hurl a lance of pure spirit energy at the foe.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
